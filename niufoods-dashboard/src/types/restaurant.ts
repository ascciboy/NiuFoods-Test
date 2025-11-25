export type DeviceSummary = {
    id: number;
    name: string;
    status: string;
    location: string | null;
    offline: boolean;
    last_connection_at: string;
};

export type RestaurantDetail = {
    id: number;
    name: string;
    city: string;
    status: string;
    issues_count: number;
    critical_issues_count: number;
    last_report_at: string;
    devices: DeviceSummary[];
};
