export interface Restaurant {
    id: number;
    name: string;
    city: string;
    status: string;
    issues_count: number;
    critical_issues_count: number;
    last_report_at: string | null;
}
