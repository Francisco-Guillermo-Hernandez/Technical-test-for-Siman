'use client';
import { Button } from 'primereact/button';
import { Chip } from 'primereact/chip';
import { Dropdown } from 'primereact/dropdown';
import { Editor } from 'primereact/editor';
import { FileUpload, FileUploadSelectEvent, FileUploadUploadEvent, ItemTemplateOptions } from 'primereact/fileupload';
import { InputSwitch } from 'primereact/inputswitch';
import { InputText } from 'primereact/inputtext';
import { classNames } from 'primereact/utils';
import React, { useRef, useState } from 'react';
import type { Demo, Product, Marca, Color } from '@/types';
import { InputTextarea } from 'primereact/inputtextarea';
import { Toast } from 'primereact/toast';

import ProductDimensions from './product-dimensions';

import { useRouter } from 'next/navigation';

import env from '@/lib/environment';
import axios from 'axios';
import { ProductDtoSchema, ProductDtoType, validateProduct } from '@/lib/validators/product.validator';

interface GenericCatalog {
    id?: number;
    nombre?: string;
    descripcion?: string;
    activo?: boolean;
    created_at?: string | Date;
    updated_at?: string | Date;
}

const saveProduct = async (form: Product) => {
    try {
        return await axios.post(
            `${env.api}products/`,
            { ...form },
            {
                headers: {
                    'Content-Type': 'application/json'
                }
            }
        );
    } catch (error) {
        throw error;
    }
};

const parserUtil = (value: string, type: 'float' | 'integer' = 'float') => {
    let parsed = value.replace(/[^0-9.]/g, '');
    const p = parsed.split('.');

    if (type === 'float') {
        if (p.length > 2) {
            parsed = p[0] + '.' + p.slice(1).join('');
        }
    } else {
        parsed = p.join('');
    }

    return parsed;
};

function NewProduct() {
    const toast = useRef(null);
    const router = useRouter();

    const [productData, setProductData] = useState<Product>({
        peso: '',
        precio: ''
    });

    const updateProductData = (field: string, value: string | number | boolean) => {
        setProductData((prev) => ({ ...prev, [field]: value }));
    };

    const [categories, setCategories] = useState<Array<GenericCatalog>>([]);
    const [isValid, setValid] = useState<boolean>();

    React.useEffect(() => {
        axios.get<Array<GenericCatalog>>(`${env.catalogs}categorias`).then((response) => {
            setCategories(response.data);
        });
    }, []);

    const [statuses, setProductStatus] = useState<Array<GenericCatalog>>([]);

    React.useEffect(() => {
        axios.get<Array<GenericCatalog>>(`${env.catalogs}estatus_producto`).then((response) => {
            setProductStatus(response.data);
        });
    }, []);

    const [marcas, setMarca] = useState<Array<Marca>>([]);

    React.useEffect(() => {
        axios.get<Array<Marca>>(`${env.catalogs}marcas`).then((response) => {
            setMarca(response.data);
        });
    }, []);

    const [colors, setColors] = useState<Array<Color>>([]);

    React.useEffect(() => {
        axios.get<Array<Color>>(`${env.catalogs}colores`).then((response) => setColors(response.data));
    }, []);

    const colorOptions = [
        { name: 'Black', background: 'bg-gray-900' },
        { name: 'Orange', background: 'bg-orange-500' },
        { name: 'Navy', background: 'bg-blue-500' }
    ];

    const [product, setProduct] = useState<Demo.Product>({
        name: '',
        price: '',
        code: '',
        sku: '',
        status: 'Draft',
        tags: ['Nike', 'Sneaker'],
        category: 'Sneakers',
        colors: [],
        stock: 'Sneakers',
        inStock: true,
        description: '',
        images: []
    });

    const [selectedCategory, setSelectedCategory] = useState(product.category);

    

    const fileUploader = useRef<FileUpload>(null);

    const chipTemplate = (tag: string) => {
        return (
            <React.Fragment>
                <span className="mr-3">{tag}</span>
                <span className="chip-remove-icon flex align-items-center justify-content-center border-1 surface-border bg-gray-100 border-circle cursor-pointer" onClick={() => onChipRemove(tag)}>
                    <i className="pi pi-fw pi-times text-black-alpha-60"></i>
                </span>
            </React.Fragment>
        );
    };

    const onImageMouseOver = (ref: React.RefObject<Button>, fileName: string) => {
        if ((ref.current as any).id === fileName) (ref.current as any).style.display = 'flex';
    };

    const onImageMouseLeave = (ref: React.RefObject<Button>, fileName: string) => {
        if ((ref.current as any).id === fileName) {
            (ref.current as any).style.display = 'none';
        }
    };

    const onChipRemove = (item: string) => {
        const newTags = (product.tags as string[])?.filter((i) => i !== item);
        setProduct((prevState) => ({ ...prevState, tags: newTags }));
    };

    const onColorSelect = (colorName: string, i: number) => {
        if ((product.colors as string[])?.indexOf(colorName) !== -1) {
            (product.colors as string[]).splice((product.colors as string[]).indexOf(colorName), 1);
            setProduct((prevState) => ({
                ...prevState,
                colors: (prevState.colors as string[]).filter((color) => color !== colorName)
            }));
        } else {
            setProduct((prevState) => ({
                ...prevState,
                colors: [...(prevState.colors as string[]), colorName]
            }));
        }
    };

    const onUpload = (event: FileUploadUploadEvent | FileUploadSelectEvent) => {
        setProduct((prevState) => ({ ...prevState, images: event.files }));
    };

    const onFileUploadClick = () => {
        const inputEl = fileUploader.current?.getInput();
        inputEl?.click();
    };

    const emptyTemplate = () => {
        return (
            <div className="h-15rem overflow-y-auto py-3 border-round" style={{ cursor: 'copy' }}>
                <div className="flex flex-column w-full h-full justify-content-center align-items-center" onClick={onFileUploadClick}>
                    <i className="pi pi-file text-4xl text-primary"></i>
                    <span className="block font-semibold text-900 text-lg mt-3">Arrastre o seleccione imagenes</span>
                </div>
            </div>
        );
    };

    const handleProduct = (e: React.MouseEvent<HTMLButtonElement>) => {
        e.preventDefault();

        console.log('Product Data');
        console.log(productData);

        const { stock, peso, costo, precio, ...remaining } = productData;

        const formattedData = {
            ...remaining,
            stock: typeof stock === 'string'?  parseInt(stock): 0,
            peso:  typeof peso === 'string'?  parseFloat(peso): 0,
            costo: typeof costo === 'string'?  parseFloat(costo): 0,
            precio: typeof precio === 'string'?  parseFloat(precio): 0,
        }

        const { isValid, errors } = validateProduct(formattedData);

        setValid(isValid);

        console.log(errors);

        if (isValid) {
            saveProduct(formattedData)
                .then((response) => {
                    console.log(response);
                    toast.current.show({ severity: 'success', summary: 'El producto se registro correctamente', detail: 'Message Content', life: 3000 });

                    setTimeout(() => router.push('/auth/login'), 500);
                })
                .catch((error) => {
                    console.error(error);
                    toast.current.show({ severity: 'error', summary: 'no se pudo registrar el producto correctamente', detail: 'Message Content', life: 3000 });
                });
        } else {
            toast.current.show({ severity: 'warn', summary: 'El formulario esta incompleto', detail: 'Complete el formulario', life: 3000 });
        }
    };

    const itemTemplate = (file: object, props: ItemTemplateOptions) => {
        const item = file as Demo.Base;
        const buttonEl = React.createRef<Button>();
        return (
            <div className="flex h-15rem overflow-y-auto py-3 border-round" style={{ cursor: 'copy' }} onClick={onFileUploadClick}>
                <div className="flex flex-row flex-wrap gap-3 border-round">
                    <div
                        className="h-full relative w-7rem h-7rem border-3 border-transparent border-round hover:bg-primary transition-duration-100 cursor-auto"
                        onMouseEnter={() => onImageMouseOver(buttonEl, item.name)}
                        onMouseLeave={() => onImageMouseLeave(buttonEl, item.name)}
                        style={{ padding: '1px' }}
                    >
                        <img src={item.objectURL} className="w-full h-full border-round shadow-2" alt={item.name} />
                        <Button
                            ref={buttonEl}
                            id={item.name}
                            type="button"
                            icon="pi pi-times"
                            className="hover:flex text-sm absolute justify-content-center align-items-center cursor-pointer w-2rem h-2rem"
                            rounded
                            style={{ top: '-10px', right: '-10px', display: 'none' }}
                            onClick={(event) => {
                                event.stopPropagation();
                                props.onRemove(event);
                            }}
                        ></Button>
                    </div>
                </div>
            </div>
        );
    };

    return (
        <div className="card">
            <Toast ref={toast}></Toast>
            <span className="block text-900 font-bold text-xl mb-4">Create Product</span>
            <div className="grid grid-nogutter flex-wrap gap-3 p-fluid">
                <div className="col-12 lg:col-8">
                    <div className="grid formgrid">
                        <div className="col-12 field">
                            <InputText type="text" value={productData.nombre} onChange={(e) => updateProductData('nombre', e.target.value)} placeholder="Nombre del producto" />
                        </div>
                        <div className="col-12 lg:col-4 field">
                            <label htmlFor="precio" className=" p-text-bold">
                                Precio
                            </label>
                            <InputText type="text" id="precio" required placeholder="$22" inputMode="decimal" value={productData.precio?.toString() ?? ''} onChange={(e) => updateProductData('precio', parserUtil(e.target.value))} />
                        </div>
                        <div className="col-12 lg:col-4 field">
                            <label htmlFor="costo" className=" p-text-bold">
                                Costo del producto
                            </label>
                            <InputText type="numeric" inputMode="numeric" id="costo" required placeholder="$19" value={productData.costo?.toString()} onChange={(e) => updateProductData('costo', parserUtil(e.target.value))} />
                        </div>
                        <div className="col-12 lg:col-4 field">
                            <label htmlFor="Sku" className=" p-text-bold">
                                Código sku del producto
                            </label>
                            <InputText type="text" placeholder="ELW-8366" required value={productData.sku} onChange={(e) => updateProductData('sku', e.target.value)} />
                        </div>

                        <div className="col-12 lg:col-4 field">
                            <label htmlFor="peso" className=" p-text-bold">
                                Peso
                            </label>
                            <InputText id="peso" type="numeric" placeholder="23.3" required inputMode="numeric" value={productData.peso?.toString() ?? ''} onChange={(e) => updateProductData('peso', parserUtil(e.target.value))} />
                        </div>

                        <div className="col-12 lg:col-4 field">
                            <label htmlFor="stock" className=" p-text-bold">
                                Stock
                            </label>
                            <InputText type="text" id="stock" placeholder="123" value={productData.stock?.toString()} onChange={(e) => updateProductData('stock', parserUtil(e.target.value, 'integer'))} />
                        </div>
                        {/*
<ProductDimensions
              onChange={() => {}}
              initialDimensions={{
                id: '1',
                height: '',
                width: '',
                length: ''
              }}
              /> */}

                        <div className="col-12 lg:col-4 field">
                            <label htmlFor="dimensiones" className=" p-text-bold">
                                Dimensiones
                            </label>
                            <InputText type="text" id="dimensiones" placeholder="12*23*22" value={productData.dimensiones} onChange={(e) => updateProductData('dimensiones', e.target.value)} />
                        </div>

                        <div className="col-12 field">
                            <label htmlFor="descripcion" className=" p-text-bold">
                                Descripcion
                            </label>
                            <InputTextarea id="descripcion" value={productData.descripcion} onChange={(e) => updateProductData('descripcion', e.target.value)}></InputTextarea>
                        </div>

                        <div className="col-12 field">
                            <Editor value={productData.resumen} style={{ height: '250px' }} onTextChange={(e) => updateProductData('resumen', e.htmlValue)}></Editor>
                        </div>
                        <div className="col-12 field">
                            <FileUpload
                                ref={fileUploader}
                                name="demo[]"
                                url="./upload.php"
                                itemTemplate={itemTemplate}
                                emptyTemplate={emptyTemplate}
                                onUpload={onUpload}
                                customUpload={true}
                                multiple
                                onSelect={onUpload}
                                accept="image/*"
                                auto
                                className={'upload-button-hidden border-1 surface-border surface-card border-round'}
                            />
                        </div>
                    </div>
                </div>

                <div className="flex-1 w-full lg:w-3 xl:w-4 flex flex-column row-gap-3">
                    {/* <div className="border-1 surface-border border-round">
                        <span className="text-900 font-bold block border-bottom-1 surface-border p-3">Publish</span>
                        <div className="p-3">
                            <div className="bg-gray-100 py-2 px-3 flex align-items-center border-round">
                                <span className="text-black-alpha-90 font-bold mr-3">Status:</span>
                                <span className="text-black-alpha-60 font-semibold">{product.status as string}</span>
                                <Button type="button" icon="pi pi-fw pi-pencil" className="text-black-alpha-60 ml-auto" text rounded></Button>
                            </div>
                        </div>
                    </div> */}

                    <div className="border-1 surface-border border-round">
                        <span className="text-900 font-bold block border-bottom-1 surface-border p-3">Marca del producto</span>
                        <div className="p-3 ">
                            <Dropdown options={marcas} optionLabel="nombre" optionValue="id" value={productData.marcaId} onChange={(e) => updateProductData('marcaId', e.value)} placeholder="Selecciona una marca" />
                        </div>
                    </div>

                    <div className="border-1 surface-border border-round">
                        <span className="text-900 font-bold block border-bottom-1 surface-border p-3">Sub categorias</span>
                        <div className="p-3">
                            <Dropdown options={categories} optionLabel="nombre" optionValue="id" value={productData.subCategoriaId} onChange={(e) => updateProductData('subCategoriaId', e.value)} placeholder="Selecciona una subcategoria" />
                        </div>
                    </div>

                    <div className="border-1 surface-border border-round">
                        <span className="text-900 font-bold block border-bottom-1 surface-border p-3">Color del producto</span>
                        <div className="p-3 ">
                            {/* {colorOptions.map((color, i) => {
                                return (
                                    <div
                                        key={i}
                                        className={classNames('w-2rem h-2rem mr-2 border-1 surface-border border-circle cursor-pointer flex justify-content-center align-items-center', color.background)}
                                        onClick={() => {
                                            onColorSelect(color.name, i);
                                        }}
                                    >
                                        {(product.colors as string[]).includes(color.name) ? <i key={i} className="pi pi-check text-sm text-white z-5"></i> : null}
                                    </div>
                                );
                            })} */}

                            <Dropdown options={colors} optionLabel="nombre" optionValue="id" value={productData.colorId} onChange={(e) => updateProductData('colorId', e.value)} placeholder="Selecciona un color" />
                        </div>
                    </div>

                    <div className="border-1 surface-border border-round">
                        <span className="text-900 font-bold block border-bottom-1 surface-border p-3">Estado del producto</span>
                        <div className="p-3">
                            <Dropdown options={statuses} optionLabel="nombre" optionValue="id" value={productData.statusId} onChange={(e) => updateProductData('statusId', e.value)} placeholder="Selecciona el estado del producto" />
                        </div>
                    </div>

                    <div className="border-1 surface-border flex justify-content-between align-items-center py-2 px-3 border-round">
                        <span className="text-900 font-bold p-3">El producto esta activo</span>
                        <InputSwitch checked={productData.activo} onChange={(e) => updateProductData('activo', e.value)}></InputSwitch>
                    </div>

                    <div className="flex flex-column sm:flex-row justify-content-between align-items-center gap-3 py-2">
                        {/* <Button className="flex-1 " security="danger" outlined label="Discard" icon="pi pi-fw pi-trash"></Button> */}
                        <Button className="flex-1 border-round" label="Registrar " icon="pi pi-fw pi-check" onClick={(e) => handleProduct(e)}></Button>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default NewProduct;
