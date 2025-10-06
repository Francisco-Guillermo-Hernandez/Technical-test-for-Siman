export type Product = {
  id?: number;
  nombre?: string;
  precio?:  string | number;
  costo?: number | string;
  stock?: number | string;
  descripcion?: string;
  resumen?: string;
  subCategoriaId?: number;
  especificaciones?: string;
  colorId?: number;
  statusId?: number;
  sku?: string;
  fichaTecnica?: Record<string, any>;
  marcaId?: number;
  peso?: number | string;
  dimensiones?: string;
  activo?: boolean;
  createdAt?: Date;
  updatedAt?: Date;
}
