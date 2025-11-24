import { useEffect, useState } from "react";
import { api } from "../../api/api";
import type { Device } from "../../types/device";
import type { Restaurant } from "../../types/restaurant";
import { useParams, useNavigate } from "react-router-dom";
import { colorByStatus } from "../../utils/statusColor";

const RestaurantDevices = () => {
    const { id } = useParams();
    const navigate = useNavigate();
    const [restaurant, setRestaurant] = useState<Restaurant | null>(null);
    const [devices, setDevices] = useState<Device[]>([]);

    useEffect(() => {
        api.get(`/restaurants/${id}`).then(res => setRestaurant(res.data));
        api.get(`/restaurants/${id}/devices`).then(res => setDevices(res.data));
    }, [id]);

    if (!restaurant) return <p className="text-center p-10">Cargando...</p>;

    return (
        <main className="max-w-4xl mx-auto py-10 px-4">
            <button
                className="mb-4 px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded"
                onClick={() => navigate("/")}
            >
                ⬅ Volver
            </button>

            <h1 className="text-3xl font-bold">{restaurant.name}</h1>
            <p className="text-gray-500 mb-6">{restaurant.city}</p>

            <div className="space-y-4">
                {devices.map(d => (
                    <div
                        key={d.id}
                        className="bg-white rounded-lg shadow p-5 hover:shadow-lg transition"
                    >
                        <h3 className="text-lg font-semibold">{d.name}</h3>

                        <p
                            className="font-bold"
                            style={{ color: colorByStatus(d.status) }}
                        >
                            Estado: {d.status.toUpperCase()}
                        </p>

                        <p>{d.critical ? "Dispositivo crítico" : "Dispositivo regular"}</p>
                        <p className="text-sm text-gray-600">{d.location ?? "Sin ubicación"}</p>
                    </div>
                ))}
            </div>
        </main>
    );
};

export default RestaurantDevices;
