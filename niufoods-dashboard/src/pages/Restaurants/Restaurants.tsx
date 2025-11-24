import { useEffect, useState } from "react";
import { api } from "../../api/api";
import type { Restaurant } from "../../types/restaurant";
import { colorByStatus } from "../../utils/statusColor";
import { useNavigate } from "react-router-dom";

const Restaurants = () => {
    const [restaurants, setRestaurants] = useState<Restaurant[]>([]);
    const navigate = useNavigate();

    useEffect(() => {
        api.get<Restaurant[]>("/restaurants").then(res => setRestaurants(res.data));
    }, []);

    return (
        <main className="max-w-4xl mx-auto py-10 px-4">
            <h1 className="text-3xl font-bold mb-6">Restaurantes</h1>

            <div className="space-y-4">
                {restaurants.map(r => (
                    <div
                        key={r.id}
                        className="bg-white rounded-lg shadow hover:shadow-lg transition cursor-pointer p-5"
                        onClick={() => navigate(`/restaurant/${r.id}`)}
                    >
                        <h3 className="text-xl font-semibold">{r.name}</h3>
                        <p className="text-gray-500">{r.city}</p>

                        <div className="mt-2 flex items-center gap-4">
                            <span
                                className="font-bold"
                                style={{ color: colorByStatus(r.status) }}
                            >
                                {r.status}
                            </span>
                            <span className="text-sm">
                                {r.issues_count} problemas · {r.critical_issues_count} críticos
                            </span>
                        </div>
                    </div>
                ))}
            </div>
        </main>
    );
};

export default Restaurants;
