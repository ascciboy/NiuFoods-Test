import { BrowserRouter, Routes, Route } from "react-router-dom";
import Restaurants from "../pages/Restaurants/Restaurants";
import RestaurantDevices from "../pages/RestaurantDevices/RestaurantDevices";
import DashboardLayout from "../components/layouts/DashboardLayout";

export const RouterProvider = () => (
    <BrowserRouter>
        <DashboardLayout>
            <Routes>
                <Route path="/" element={<Restaurants />} />
                <Route path="/restaurant/:id" element={<RestaurantDevices />} />
            </Routes>
        </DashboardLayout>
    </BrowserRouter>
);
