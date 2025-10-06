'use client';

import React, { useEffect, useState } from 'react';
import { Button } from 'primereact/button';
import { Column } from 'primereact/column';
import { DataTable } from 'primereact/datatable';
import { InputText } from 'primereact/inputtext';
import { Paginator } from 'primereact/paginator';
import type { Demo } from '@/types';
import axios from 'axios';
import env from '@/lib/environment';






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
    products: Array<Demo.Product>;
}

const TableDemo = () => {
    const [filters, setFilters] = useState<Filters>({ page: 1, pageSize: 10 });
    const [loading, setLoading] = useState(false);
    const [products, setProducts] = useState<Demo.Product[]>([]);
    const [paginatorInfo, setPaginatorInfo] = useState<Omit<GenericPaginator, 'products'>>();
    const [globalFilterValue, setGlobalFilterValue] = useState('');
    const [first, setFirst] = useState(0);





    const clearFilter = () => {
        // initFilters();
    };

    const onPageChange = (event: any) => {
        setFilters({ ...filters, page: event.page + 1, pageSize: event.rows });
        setFirst(event.first);
    };

    useEffect(() => {
        const fetchProductsData = async () => {
            setLoading(true);
            try {
                const params = new URLSearchParams({
                    page: filters.page.toString(),
                    pageSize: filters.pageSize.toString()
                }).toString();

                const { data } = await axios.get<GenericPaginator>(`${env.api}products/?${params}`);
                const { products: fetchedProducts, ...remaining } = data;
                setProducts(fetchedProducts);
                setPaginatorInfo(remaining);
            } catch (error) {
                console.error('Error fetching products:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchProductsData();
    }, [filters]);

    const onGlobalFilterChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const value = e.target.value;



        setGlobalFilterValue(value);
    };

    const renderHeader = () => {
        return (
            <div className="flex justify-content-between">
                {/* <Button type="button" icon="pi pi-filter-slash" label="Limpiar" outlined onClick={clearFilter} />
                <span className="p-input-icon-left">
                    <i className="pi pi-search" />
                    <InputText value={globalFilterValue} onChange={onGlobalFilterChange} placeholder="Buscar por nombre" />
                </span> */}
            </div>
        );
    };


    const formatCurrency = (value: number) => {
        return value.toLocaleString('en-US', {
            style: 'currency',
            currency: 'USD'
        });
    };

    const amountBodyTemplate = (rowData: Demo.Customer) => {
        return formatCurrency(rowData.amount as number);
    };

    const statusOrderBodyTemplate = (rowData: Demo.Customer) => {
        return <span className={`order-badge order-${rowData.status?.toLowerCase()}`}>{rowData.status}</span>;
    };

    const searchBodyTemplate = () => {
        return <Button icon="pi pi-search" />;
    };


    const rowExpansionTemplate = (data: Demo.Product) => {
        return (
            <div className="orders-subtable">
                <h5>Orders for {data.name}</h5>
                <DataTable value={data.orders} responsiveLayout="scroll">
                    <Column field="id" header="Id" sortable></Column>
                    <Column field="customer" header="Customer" sortable></Column>
                    <Column field="date" header="Date" sortable></Column>
                    <Column field="amount" header="Amount" body={amountBodyTemplate} sortable></Column>
                    <Column field="status" header="Status" body={statusOrderBodyTemplate} sortable></Column>
                    <Column headerStyle={{ width: '4rem' }} body={searchBodyTemplate}></Column>
                </DataTable>
            </div>
        );
    };




    return (
        <div className="grid">
            <div className="col-12">
                <div className="card">
                    <h5>Productos</h5>
                    <DataTable
                        value={products}
                        className="p-datatable-gridlines"
                        showGridlines
                        rows={filters.pageSize}
                        first={first}
                        dataKey="id"
                        filterDisplay="menu"
                        loading={loading}
                        responsiveLayout="scroll"
                        emptyMessage="No se encontraron productos"
                        header={renderHeader()}

                        rowExpansionTemplate={rowExpansionTemplate}
                    >
                        <Column expander style={{ width: '3em' }} />
                        <Column field="nombre" header="Nombre" sortable filter filterPlaceholder="Buscar por nombre" />
                        <Column field="descripcion" header="Descripción" sortable filter filterPlaceholder="Buscar por descripción" />
                        <Column field="precio" header="Precio" sortable body={(rowData) => `$${rowData.precio.toFixed(2)}`} />
                        <Column field="subCategoriaId" header="Categoría" sortable filter filterPlaceholder="Buscar por categoría" />

                        <Column field="modificar" header="Modificar"   filterPlaceholder="Buscar por categoría" > <Button label="Modificar"></Button>  </Column>
                    </DataTable>
                    <Paginator
                        first={first}
                        rows={filters.pageSize}
                        totalRecords={paginatorInfo?.total || 0}
                        rowsPerPageOptions={[5, 10, 20, 30]}
                        onPageChange={onPageChange}
                    />
                </div>
            </div>


        </div>
    );
};

export default TableDemo;
