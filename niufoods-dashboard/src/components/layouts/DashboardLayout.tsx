import type { ReactNode } from "react";

interface Props {
    children: ReactNode;
}

const DashboardLayout = ({ children }: Props) => {

    return (
        <div className="min-h-screen bg-gray-100 flex flex-col">
            <header className="bg-white shadow flex items-center justify-between px-6 py-4">
                <h1 className="text-lg font-bold">Niufoods Monitor</h1>
            </header>

            <div className="flex flex-1">
                <main className="flex-1 p-6">{children}</main>
            </div>
        </div>
    );
};

export default DashboardLayout;
