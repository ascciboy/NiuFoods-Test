export interface Device {
    id: number;
    name: string;
    status: string;
    critical: boolean;
    last_connection_at: string | null;
    location: string | null;
}
