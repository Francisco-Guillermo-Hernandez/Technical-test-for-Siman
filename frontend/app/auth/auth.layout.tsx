export default function AuthLayout({ children, title, description }: Readonly<{ children: React.ReactNode; title: string; description: string }>) {
    return (
        <div className="flex h-screen">
            {children}
            <div
                className="w-8 hidden lg:flex flex-column justify-content-between align-items-center px-6 py-6 bg-cover bg-norepeat"
                style={{
                    backgroundImage: "url('/demo/images/auth/bg-login.jpg')"
                }}
            >
                <div className="mt-auto mb-auto">
                    <span className="block text-white text-7xl font-semibold">{title}</span>
                    <span className="block text-white text-3xl mt-4">{description}</span>
                </div>
            </div>
        </div>
    );
}
