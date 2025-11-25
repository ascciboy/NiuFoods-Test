require "typhoeus"
require "json"

BASE_URL     = ENV.fetch("SIM_API_URL", "http://localhost:3000/api/v1")
DEVICE_LIMIT = ENV.fetch("SIM_DEVICES", 25).to_i
THREADS      = ENV.fetch("SIM_THREADS", 8).to_i

puts "NIU Foods Simulador Optimizado"
puts "API: #{BASE_URL}"
puts "Devices simulados: #{DEVICE_LIMIT}"

STATUS_POOL = {
  "operative" => 75,
  "warning"   => 15,
  "trouble"   => 7,
  "critical"  => 3
}
def random_status
  STATUS_POOL.flat_map { |k,v| [k] * v }.sample
end

def metrics_for(status)
  case status
  when "critical"
    {
      temperature_celsius: rand(80..95),
      battery_level: rand(1..15),
      packet_loss_pct: rand(20..60),
      cpu_usage: rand(60..100),
      memory_usage: rand(60..100),
      network_latency_ms: rand(200..500)
    }
  when "trouble"
    {
      temperature_celsius: rand(65..85),
      battery_level: rand(10..40),
      packet_loss_pct: rand(10..40),
      network_latency_ms: rand(150..400),
      cpu_usage: rand(40..80)
    }
  when "warning"
    {
      temperature_celsius: rand(50..70),
      battery_level: rand(20..60),
      network_latency_ms: rand(80..200),
      packet_loss_pct: rand(5..15),
      cpu_usage: rand(20..60)
    }
  else # operative
    {
      temperature_celsius: rand(25..55),
      battery_level: rand(30..100),
      network_latency_ms: rand(10..120),
      packet_loss_pct: rand(0..5),
      cpu_usage: rand(5..40)
    }
  end
end

resp = Typhoeus.get("#{BASE_URL}/restaurants", headers: { "Accept" => "application/json" })
restaurants = JSON.parse(resp.body) rescue []

abort("No hay restaurantes en la API") if restaurants.empty?

restaurant_devices = restaurants.to_h do |r|
  dev = Typhoeus.get("#{BASE_URL}/restaurants/#{r["id"]}/devices", headers: { "Accept" => "application/json" })
  list = JSON.parse(dev.body).map { |d| d["id"] }.sample(DEVICE_LIMIT) 
  [r["id"], list]
end

def report(device_id, payload)
  Typhoeus.post(
    "#{BASE_URL}/devices/#{device_id}/report",
    headers: {
      "Content-Type" => "application/json",
      "Accept"       => "application/json"
    },
    body: payload.to_json
  )
rescue => e
  puts "Error device #{device_id}: #{e}"
end

def build_payload
  status = random_status
  payload = { status: status }

  payload[:download_speed_mbps] = rand(5..400)
  payload[:upload_speed_mbps]   = rand(1..80)
  payload[:connected_clients_count] = rand(0..60)
  payload[:paper_status]        = %w[ok low empty].sample
  payload[:recording_status]    = %w[recording idle error].sample
  payload[:storage_available_gb] = rand(0.1..100.0).round(2)

  payload.merge!(metrics_for(status))
  payload
end

restaurant_threads = restaurant_devices.map do |rest_id, devices|
  Thread.new do
    loop do
      devices.each do |device|
        report(device, build_payload)
        sleep(rand(0.01..0.05))
      end

      sleep(rand(4.0..7.0))
    end
  end
end

restaurant_threads.each(&:join)
