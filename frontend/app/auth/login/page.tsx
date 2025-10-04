'use client';

import React from 'react';
import { Button } from 'primereact/button';
import { InputText } from 'primereact/inputtext';
import { Page } from '@/types/layout';
import { useRouter } from 'next/navigation';

import { Toast } from 'primereact';
import {
  validateLogin,
  type CustomZodError,
} from '@/lib/validators/login.validator';
import AuthLayout from '../auth.layout';

function LoginPage() {

    const router = useRouter();
    const [isLoading, setIsLoading] = React.useState(false);
    const [password, setPassword] = React.useState<string | undefined>();
    const [email, setEmail] = React.useState<string | undefined>();
    const [errors, setErrors] = React.useState<CustomZodError>({
        email: '',
        password: '',
    });


    const handleErrors = () => {
        const { isValid, errors } = validateLogin({ email, password });
        setErrors(errors);

       return isValid;
    }

    const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();

        handleErrors();

        try {

            console.log(password);
            console.log(email);
        } catch (error) {

        }

    }


    return (
         <AuthLayout title='Accede a tu cuenta' description='...'>
            <div className="w-full lg:w-4 h-full text-center px-6 py-6 flex flex-column justify-content-between">
                    <img src={`/layout/images/logo-dark.svg`} className="h-4rem mt-4" alt="siman-layout" />

                    <div className="flex flex-column align-items-center gap-4">
                        <div className="mb-3">
                            <h2>Log in </h2>
                            <p>
                                Olvidaste tu contraseña? <a href='/auth/forgotpassword' className="text-primary hover:underline cursor-pointer font-medium">Click aqui</a> para resetear.
                            </p>
                        </div>
                       <form onSubmit={handleSubmit}>
                        <InputText id="email"
                        placeholder="Email"
                        className="w-20rem"
                        value={email}
                        onChange={(e) => { setEmail(e.target.value); handleErrors() } } required />

                        <InputText id="password"
                        type="password"
                        placeholder="Password"
                        className="w-20rem"
                         value={password}
                         onChange={(e) => { setPassword(e.target.value); handleErrors() } } required />
                        <Button label="Continuar" className="w-20rem" type='submit' disabled={errors.email != null || errors.password != null} ></Button>
                       </form>
                    </div>

                    <p className="text-color-secondary font-semibold">
                        Tienes problemas para acceder? <a className="text-primary hover:underline cursor-pointer font-medium">Haz click aqui</a>.
                    </p>
                </div>
         </AuthLayout>
    );
};

export default LoginPage;
