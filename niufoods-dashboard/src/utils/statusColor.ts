export const colorByStatus = (status: string): string => {
    const map: Record<string, string> = {
        "Operativo": "green",
        "Warning": "orange",
        "Problemas": "red",
        "Crítico": "darkred",
        "Unknown": "gray",
        "operational": "green",
        "maintenance": "orange",
        "failing": "red",
        "unknown": "gray"
    };
    return map[status] ?? "gray";
};
