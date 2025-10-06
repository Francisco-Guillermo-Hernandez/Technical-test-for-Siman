
'use client';
import { Button } from 'primereact/button';
import React, { useState, useEffect } from 'react';

import { DataView, DataViewLayoutOptions } from 'primereact/dataview';
import { Dropdown, DropdownChangeEvent } from 'primereact/dropdown';
import { Rating } from 'primereact/rating';
import { InputText } from 'primereact/inputtext';
import type { Product } from '@/types';
import axios from 'axios';
import { Paginator } from 'primereact/paginator';

import env from '@/lib/environment';

function Home() {
    return (
        <ListDemo />
    );
}

export default Home;

type Filters = {
    page: number;
    pageSize: number;
}

type GenericPaginator = {
    page: number;
    total: number;
    hasPrev: boolean;
    hasNext: boolean;
    totalPages: number;
    products: Array<Product>;
}

const ListDemo = () => {
    const [isLoading, setLoading] = useState(false);
    const [filters, setFilters] = useState<Filters>({ page: 1, pageSize: 9 });
    const [dataViewValue, setDataViewValue] = useState<Omit<GenericPaginator, 'products'>>();
    const [layout, setLayout] = useState<'grid' | 'list'>('grid');
    const [httpError, setError] = useState<string | null>(null);
    const [globalFilterValue, setGlobalFilterValue] = useState('');
    const [sortOrder, setSortOrder] = useState<0 | 1 | -1 | null>(null);
    const [sortField, setSortField] = useState('');

    const [first, setFirst] = useState(1);

    const [filteredValue, setFilteredValue] = useState<Array<Product> | null>(null);

    const [sortKey, setSortKey] = useState(null);
    const [products, setProducts] = useState<Array<Product>>([]);

    const fetchProducts = async (filters: Filters) => {
        setLoading(true);
        try {
            const params = new URLSearchParams({
                page: filters.page.toString(),
                pageSize: filters.pageSize.toString()
            }).toString();

            const { data } = await axios.get<GenericPaginator>(`${env.api}products/?${params}`);
            const { products, ...remaining } = data;
            setProducts(products);
            setDataViewValue(remaining)
        } catch (error) {
            setError('Error al recuperar los productos');
            console.error(error);
        } finally {
            setLoading(false);
        }
    }

    useEffect(() => {
        fetchProducts(filters);
    }, [filters]);


      const sortOptions = [
        { label: 'De mayor a menor', value: '!precio' },
        { label: 'De menor a mayor', value: 'precio' }
    ];

     const onSortChange = (event: DropdownChangeEvent) => {
        const value = event.value;

        if (value.indexOf('!') === 0) {
            setSortOrder(-1);
            setSortField(value.substring(1, value.length));
            setSortKey(value);
        } else {
            setSortOrder(1);
            setSortField(value);
            setSortKey(value);
        }
    };

 const onFilter = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;
        setGlobalFilterValue(value);
        if (value.length === 0) {
            setFilteredValue(null);
        } else {
            const filtered = products?.filter((product) => {
                const productNameLowercase = product.nombre.toLowerCase();
                const searchValueLowercase = value.toLowerCase();
                return productNameLowercase.includes(searchValueLowercase);
            });

            setFilteredValue(filtered);
        }
    };


       const dataViewHeader = (
        <div className="flex flex-column md:flex-row md:justify-content-between gap-2">
            <Dropdown value={sortKey} options={sortOptions} optionLabel="label" placeholder="Ordenar por precio" onChange={onSortChange} />
            <span className="p-input-icon-left">
                <i className="pi pi-search" />
                <InputText value={globalFilterValue} onChange={onFilter} placeholder="Buscar por nombre" />
            </span>
        </div>
    );




    const itemTemplate = (data: Product, layout: 'grid' | 'list') => {
        if (!data) return null;

        return (
            <div className="col-12 lg:col-4">
                <div className="card m-3 border-1 surface-border">
                    <div className="flex flex-wrap gap-2 align-items-center justify-content-between mb-2">
                        <div className="flex align-items-center">
                            <i className="pi pi-tag mr-2" />
                            <span className="font-semibold">{data.subCategoriaId}</span>
                        </div>
                    </div>
                    <div className="flex flex-column align-items-center text-center mb-3">
                        <img src={`https://picsum.photos/200/150?random=${data.id}`} alt={data.nombre} className="w-9 shadow-2 my-3 mx-0" />
                        <div className="text-2xl font-bold">{data.nombre}</div>
                        <div className="mb-3">{data.descripcion}</div>
                    </div>
                    <div className="flex align-items-center justify-content-between">
                        <span className="text-2xl font-semibold">${data.precio}</span>
                    </div>
                </div>
            </div>
        );
    };

    const onPageChange = (event: any) => {


        setFilters({ ...filters, page: event?.page + 1 })
        setFirst(event.first);
        console.log(event);

    };

    return (
        <div className="grid">
            <div className="col-12">
                <div className="card">
                    <DataView
                        value={ filteredValue || products ||  []}
                        layout={layout}
                        rows={filters.pageSize}
                        first={first}
                        totalRecords={dataViewValue?.total || 0}
                        onPage={onPageChange}
                        loading={isLoading}
                        itemTemplate={itemTemplate}
                        header={dataViewHeader}
                        sortOrder={sortOrder}
                         sortField={sortField}
                    />
                    <Paginator
                        first={first}
                        rows={filters.pageSize}
                        totalRecords={dataViewValue?.total}
                        onPageChange={onPageChange}
                    />
                </div>
            </div>
        </div>
    );
};
