import { MenuModal } from '@/types/layout';
import AppSubMenu from './AppSubMenu';

const AppMenu = () => {
    const model: MenuModal[] = [

        {
            label: 'Productos',
            icon: 'pi pi-fw pi-wallet',
            items: [
                {
                    label: 'Product Overview',
                    icon: 'pi pi-fw pi-image',
                    to: '/ecommerce/product-overview'
                },
                {
                    label: 'Product List',
                    icon: 'pi pi-fw pi-list',
                    to: '/ecommerce/product-list'
                },
                {
                    label: 'New Product',
                    icon: 'pi pi-fw pi-plus',
                    to: '/ecommerce/new-product'
                },
                {
                    label: 'Shopping Cart',
                    icon: 'pi pi-fw pi-shopping-cart',
                    to: '/ecommerce/shopping-cart'
                },
                {
                    label: 'Checkout Form',
                    icon: 'pi pi-fw pi-check-square',
                    to: '/ecommerce/checkout-form'
                },
                {
                    label: 'Order History',
                    icon: 'pi pi-fw pi-history',
                    to: '/ecommerce/order-history'
                },
                {
                    label: 'Order Summary',
                    icon: 'pi pi-fw pi-file',
                    to: '/ecommerce/order-summary'
                }
            ]
        },


    ];

    return <AppSubMenu model={model} />;
};

export default AppMenu;
