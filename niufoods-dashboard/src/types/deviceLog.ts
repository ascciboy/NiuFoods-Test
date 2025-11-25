export type DeviceLog = {
    id: number;
    previous_status: string;
    new_status: string;
    reason?: string;
    details?: string;
    metrics_snapshot?: Record<string, any>;
    reported_at?: string;
    processed_at?: string;
    created_at: string;
};
