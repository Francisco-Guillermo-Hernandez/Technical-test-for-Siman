import { z } from 'zod';

export const ProductDtoSchema = z.object({
  nombre: z.string()
    .min(1, { message: "El Nombre es requerido" })
    .max(60, { message: "El nombre debe de tener menos de 60 caracteres" }),

  precio: z.union([
    z.number().positive({ message: "El precio debe de ser mayor a 0" }),
    z.string().regex(/^\d+(\.\d{1,2})?$/, { message: "Precio debe de contener numeros y decimales" })
  ])
    .refine((value) => {
      if (typeof value === 'number') {
        return value >= 0.01;
      }
      const num = parseFloat(value);
      return num >= 0.01;
    }, { message: "El precio debe de ser mayor a 0" }),

  costo: z.union([
    z.number().positive({ message: "El costo debe de ser mayor a 0" }),
    z.string().regex(/^\d+(\.\d{1,2})?$/, { message: "El costo debe de contener cifras" })
  ])
    .refine((value) => {
      if (typeof value === 'number') {
        return value >= 0.01;
      }
      const num = parseFloat(value);
      return num >= 0.01;
    }, { message: "El costo debe de ser mayor a 0" }),

  stock: z.number()
    .min(0, { message: "El Stock debe de ser mayor a 0" }),

  resumen: z.string().max(250, { message: "El Resumen debe de contener menos de 250 caracteres." }),

  descripcion: z.string().max(250, { message: "La descripción debe de contener menos de 250 caracteres." }),

  subCategoriaId: z.number(),

  colorId: z.number(),

  statusId: z.number(),

  sku: z.string()
    .min(1, { message: "SKU is required" })
    .max(100, { message: "SKU debe de contener menos de 100 caracteres." })
    .regex(/^[a-zA-Z0-9\-_]+$/, { message: "SKU puede contener letras, números, guiones y guiones bajos" }),

  fichaTecnica: z.record(z.string(), z.any()).optional(),

  marcaId: z.number().optional(),

  peso: z.union([
    z.number().positive({ message: "El peso debe de ser mayor a 0" }),
    z.string().regex(/^\d+(\.\d{1,3})?$/, { message: "Peso debe contener números y decimales" })
  ])
    .refine((value) => {
      if (typeof value === 'number') {
        return value >= 0.001;
      }
      const num = parseFloat(value);
      return num >= 0.001;
    }, { message: "El peso debe de ser mayor a 0" }),

  dimensiones: z.string().max(70, { message: "Las dimensiones deben de contener menos de 70 caracteres" }),

  activo: z.boolean().optional(),

  createdAt: z.date().optional(),

  updatedAt: z.date().optional()
});


export type ProductDtoType = z.infer<typeof ProductDtoSchema>;


export const validateProduct = (data: Partial<ProductDtoType>) => {
  try {
    ProductDtoSchema.parse(data);
    return { isValid: true, errors: {} };
  } catch (error) {
    if (error instanceof z.ZodError) {


      const ff = error.flatten().fieldErrors;

      const errors = {
       ...ff
      };

      return { isValid: false, errors };
    }
    return { isValid: false, errors: {}};
  }
};
