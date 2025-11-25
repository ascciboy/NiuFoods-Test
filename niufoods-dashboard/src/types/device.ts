export type DeviceSummary = {
    id: number;
    name: string;
    status: string;
    location: string | null;
    offline: boolean;
    last_connection_at: string;
};