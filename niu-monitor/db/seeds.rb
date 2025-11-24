require "faker"

puts "Resetting data..." if Rails.env.development?

DeviceLog.delete_all
Device.delete_all
DeviceType.delete_all
Restaurant.delete_all

NUM_RESTAURANTS = 10
MIN_DEV = 4
MAX_DEV = 10

DEVICE_MODELS_CL = {
  "POS Terminal" => [
    "Sunmi T2", "Sunmi V2s", "Ingenico MOVE/3500",
    "Ingenico Desk/5000", "Verifone VX520", "Verifone VX820 DUET"
  ],
  "Fiscal Printer" => [
    "Epson TM-T88V", "Epson TM-T20III", "Bematech MP-4200 TH", "Star mC-Print3"
  ],
  "WiFi Router" => [
    "TP-Link Archer C6", "TP-Link Archer AX23", "Mikrotik hAP AC Lite",
    "Mikrotik hEX S", "Cisco Meraki Go GR10"
  ],
  "QR Scanner" => [
    "Zebra DS2208", "Honeywell Voyager 1450g", "Newland HR20"
  ],
  "Kitchen Screen (KDS)" => [
    "Sunmi K2", "Oracle MICROS KDS", "Elo 15-E3"
  ],
  "Security Camera" => [
    "Hikvision DS-2CD2143G0", "Dahua IPC-HFW2431", "Reolink RLC-820A"
  ],
  "Cash Register" => [
    "Sharp XE-A207B", "Casio SE-S100", "Epson FP-90III"
  ]
}.freeze

puts "Creating device types..."

DEVICE_MODELS_CL.keys.each do |type_name|
  DeviceType.create!(
    name: type_name,
    requires_network: type_name != "Cash Register"
  )
end

puts "Creating restaurants..."

CITIES = %w[
  Santiago Valparaiso Vina Concepcion Osorno Temuco
  Rancagua Iquique Antofagasta Talca
].freeze

city_counters = Hash.new(0)

restaurants = NUM_RESTAURANTS.times.map do
  city = CITIES.sample
  city_counters[city] += 1
  idx = city_counters[city]

  Restaurant.create!(
    name: idx > 1 ? "NiuFoods - #{city} ##{idx}" : "NiuFoods - #{city}",
    city: city,
    active: true,
    last_report_at: Faker::Time.backward(days: 3)
  )
end

puts "Assigning devices..."

LOCATIONS_BY_TYPE = {
  "POS Terminal" => ["Caja", "Caja Principal", "Barra", "Mostrador"],
  "Fiscal Printer" => ["Caja", "Área de Pagos", "Impresión Fiscal"],
  "WiFi Router" => ["Bodega", "Administración", "Sala de Servidores", "Techo/Bodega"],
  "QR Scanner" => ["Caja", "Mostrador", "Mesón de Retiro"],
  "Kitchen Screen (KDS)" => ["Cocina", "Línea de Platos", "Área de Preparación"],
  "Security Camera" => ["Entrada", "Caja", "Cocina", "Terraza"],
  "Cash Register" => ["Caja", "Caja Principal", "Barra"]
}.freeze

restaurants.each do |restaurant|
  rand(MIN_DEV..MAX_DEV).times do |index|
    dtype = DeviceType.all.sample
    model = DEVICE_MODELS_CL[dtype.name].sample
    location = LOCATIONS_BY_TYPE[dtype.name].sample

    unique_name = "#{model} - #{format('%02d', index + 1)}"

    restaurant.devices.create!(
      device_type: dtype,
      name: unique_name,
      critical: false,
      status: "operative",
      location: location,
      firmware_version: "v#{rand(1..3)}.#{rand(0..10)}.#{rand(0..99)}",
      ip_address: dtype.requires_network ? Faker::Internet.ip_v4_address : nil,
      is_network_reachable: true,
      last_connection_at: Faker::Time.backward(days: 1)
    )
  end

  restaurant.update_overall_status!
end

puts "Seeds completed successfully!"
