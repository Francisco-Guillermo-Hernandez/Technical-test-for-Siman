'use client';

import React from 'react';
import { InputText } from 'primereact/inputtext';
import { Button } from 'primereact/button';
import { useRouter } from 'next/navigation';
import { Page } from '@/types/layout';

import AuthLayout from '../auth.layout';

const ForgotPassword: Page = () => {
    const router = useRouter();

    return (
         <AuthLayout title='Resetea tu contraseña' description='...'>
             <div className="w-full lg:w-4 h-full text-center px-6 py-6 flex flex-column justify-content-between">
                    <img src={`/layout/images/logo-dark.svg`} className="h-4rem mt-4" alt="siman-layout" />
                    <div className="flex flex-column align-items-center gap-4">
                        <div className="mb-3">
                            <h2>Olvidaste tu contraseña?</h2>
                            <p>Ingresa tu email para resetearla</p>
                        </div>

                        <form className='h-[32px]'>
                            <span className="p-input-icon-left w-full md:w-25rem">
                            <i className="pi pi-envelope"></i>
                            <InputText id="email" type="text" className="w-full md:w-25rem" placeholder="Email" />
                        </span>

                        <div className="flex gap-3 w-full md:w-25rem">

                            <Button className="p-ripple flex-auto" onClick={() => router.push('/')} label="Enviar"></Button>
                        </div>
                        </form>
                    </div>

                    <p className="text-color-secondary font-semibold">
                        A problem? <a className="text-primary hover:underline cursor-pointer font-medium">Click here</a> and let us help you.
                    </p>
                </div>
         </AuthLayout>
    );
};

export default ForgotPassword;
