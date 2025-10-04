'use client';

import React from 'react';

import { useContext } from 'react';

import { LayoutContext } from './context/layoutcontext';

const AppFooter = () => {
    const { layoutConfig } = useContext(LayoutContext);

    return (
        <div className="layout-footer">
            <div className="footer-logo-container">

                
            </div>
            <span className="footer-copyright"></span>
        </div>
    );
};

export default AppFooter;
