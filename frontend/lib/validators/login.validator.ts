import { z } from 'zod';

export const loginSchema = z.object({
  email: z.email('Por favor ingresa un correo válido'),
  password: z.string().min(6, 'La contraseña debe tener al menos 6 caracteres')
});

export type LoginFormData = z.infer<typeof loginSchema>;

export type CustomZodError = {
  email?:  string;
  password?: string;
}

export const validateLogin = (data: Partial<LoginFormData>) => {
  try {
    loginSchema.parse(data);
    return { isValid: true, errors: {} };
  } catch (error) {
    if (error instanceof z.ZodError) {


      const ff = error.flatten().fieldErrors as CustomZodError

      const errors: CustomZodError = {

        email: ff?.email,
        password: ff?.password
      };

      return { isValid: false, errors };
    }
    return { isValid: false, errors: {}};
  }
};
