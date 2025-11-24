import { useState } from "react";
import type { ReactNode } from "react";
import { Link, useLocation } from "react-router-dom";

interface Props {
    children: ReactNode;
}

const DashboardLayout = ({ children }: Props) => {
    const [open, setOpen] = useState(false);
    const { pathname } = useLocation();

    const linkClass = (route: string) =>
        `block px-4 py-2 rounded-lg font-medium hover:bg-gray-200 transition ${pathname === route ? "bg-gray-300" : ""
        }`;

    return (
        <div className="min-h-screen bg-gray-100 flex flex-col">
            <header className="bg-white shadow flex items-center justify-between px-6 py-4">
                <h1 className="text-lg font-bold">Niufoods Monitor</h1>

                <button
                    className="md:hidden px-3 py-2 bg-gray-200 rounded"
                    onClick={() => setOpen(!open)}
                >
                    ☰
                </button>
            </header>

            <div className="flex flex-1">
                <aside
                    className={`bg-white w-64 p-4 border-r shadow-md flex-col gap-4 ${open ? "block" : "hidden"
                        } md:flex`}
                >
                    <nav className="space-y-2">
                        <Link to="/" className={linkClass("/")}>
                            Restaurantes
                        </Link>

                        <Link to="/stats" className={linkClass("/stats")}>
                            Estadísticas
                        </Link>

                        <Link to="/settings" className={linkClass("/settings")}>
                            Configuración
                        </Link>
                    </nav>
                </aside>

                <main className="flex-1 p-6">{children}</main>
            </div>
        </div>
    );
};

export default DashboardLayout;
