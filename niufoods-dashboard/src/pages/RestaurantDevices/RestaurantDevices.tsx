import { useEffect, useState } from "react";
import { api } from "../../api/api";
import type { RestaurantDetail } from "../../types/restaurant";
import type { DeviceLog } from "../../types/deviceLog.ts";
import { useParams, useNavigate } from "react-router-dom";
import { colorByStatus } from "../../utils/statusColor";

const RestaurantDevices = () => {
    const { id } = useParams();
    const navigate = useNavigate();

    const [restaurant, setRestaurant] = useState<RestaurantDetail | null>(null);
    const [logs, setLogs] = useState<DeviceLog[]>([]);
    const [showModal, setShowModal] = useState(false);
    const [selectedDevice, setSelectedDevice] = useState<number | null>(null);

    useEffect(() => {
        api.get(`/restaurants/${id}`).then(res => setRestaurant(res.data));
    }, [id]);

    const openLogs = async (deviceId: number) => {
        setSelectedDevice(deviceId);
        const res = await api.get(`/devices/${deviceId}/logs?limit=10`);
        setLogs(res.data);
        setShowModal(true);
    };

    if (!restaurant) return <p className="text-center p-10">Cargando...</p>;

    return (
        <main className="max-w-4xl mx-auto py-10 px-4">
            <button
                className="mb-4 px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded"
                onClick={() => navigate("/")}
            >
                Volver
            </button>

            <h1 className="text-3xl font-bold">{restaurant.name}</h1>
            <p className="text-gray-500 mb-6">{restaurant.city}</p>

            <div className="space-y-4">
                {restaurant.devices.map(d => (
                    <div
                        key={d.id}
                        className="bg-white rounded-lg shadow p-5 hover:shadow-lg transition cursor-pointer"
                        onClick={() => openLogs(d.id)}
                    >
                        <h3 className="text-lg font-semibold flex justify-between">
                            {d.name}
                            {d.offline && (
                                <span className="text-red-600 text-sm font-bold ml-2">
                                    ● OFFLINE
                                </span>
                            )}
                        </h3>

                        <p className="font-bold" style={{ color: colorByStatus(d.status) }}>
                            {d.status.toUpperCase()}
                        </p>

                        <p className="text-sm text-gray-600">Ubicación: {d.location ?? "Sin ubicación"}</p>

                        <p className="text-xs text-gray-500 mt-2">
                            Último reporte: {new Date(d.last_connection_at).toLocaleString()}
                        </p>
                    </div>
                ))}
            </div>

            {showModal && selectedDevice && (
                <div className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
                    <div className="bg-white rounded-lg shadow-lg w-full max-w-xl p-6 relative">
                        <h2 className="text-xl font-semibold mb-4">Últimos eventos del dispositivo #{selectedDevice}</h2>

                        <button
                            className="absolute top-3 right-3 text-gray-500 hover:text-black"
                            onClick={() => setShowModal(false)}
                        >
                            ✖
                        </button>

                        <div className="max-h-96 overflow-y-auto space-y-3">
                            {logs.length === 0 && (
                                <p className="text-center text-gray-600">No hay eventos registrados.</p>
                            )}

                            {logs.map(l => (
                                <div
                                    key={l.id}
                                    className="border rounded p-3 bg-gray-50"
                                >
                                    <p className="text-sm font-semibold" style={{ color: colorByStatus(l.new_status) }}>
                                        {l.previous_status.toUpperCase()} → {l.new_status.toUpperCase()}
                                    </p>

                                    <p className="text-xs text-gray-600">{l.reason ?? "Sin razón"}</p>

                                    {l.metrics_snapshot && Object.keys(l.metrics_snapshot).length > 0 && (
                                        <pre className="text-xs bg-gray-200 mt-2 p-2 rounded">
                                            {JSON.stringify(l.metrics_snapshot, null, 2)}
                                        </pre>
                                    )}

                                    <p className="text-[11px] text-gray-500 mt-1">
                                        {new Date(l.created_at).toLocaleString()}
                                    </p>
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}
        </main>
    );
};

export default RestaurantDevices;
