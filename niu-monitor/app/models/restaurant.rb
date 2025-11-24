class Restaurant < ApplicationRecord
  has_many :devices, dependent: :destroy

  def update_overall_status!
    critical = devices.where(status: "critical")
    trouble  = devices.where(status: "trouble")
    warning  = devices.where(status: "warning")

    update(
      status: determine_status(critical, trouble, warning),
      issues_count: devices.where.not(status: "operative").count,
      critical_issues_count: critical.count,
      last_report_at: devices.maximum(:last_connection_at)
    )
  end

  private

  def determine_status(critical, trouble, warning)
    return "unknown"  if devices.none?
    return "critical" if critical.exists?
    return "trouble"  if trouble.exists?
    return "warning"  if warning.exists?
    "operative"
  end
end
