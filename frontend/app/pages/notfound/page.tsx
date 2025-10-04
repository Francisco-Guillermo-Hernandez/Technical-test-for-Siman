'use client';

import React from 'react';

function NotFound() {
    return (
        <div className="px-5 min-h-screen flex justify-content-center align-items-center bg-cover bg-center" style={{ backgroundImage: 'url(/demo/images/notfound/bg-404.jpg)' }}>
            <div className="z-1 text-center">
                <div className="text-900 font-bold text-white text-8xl mb-4">404</div>
                <p className="line-height-3 text-white mt-0 mb-5 text-700 text-xl font-medium">El recurso solicitado no se encuentra.</p>
            </div>
        </div>
    );
}

export default NotFound;
