'use client';

import React, { useState, useEffect } from 'react';
import { InputText } from 'primereact/inputtext';

interface DimensionInputsProps {
  onChange?: (dimensions: {
    length: string;
    height: string;
    width: string;
  }) => void;
  initialDimensions?: {
    id: string,
    length?: string;
    height?: string;
    width?: string;
  };
}

const DimensionInputs: React.FC<DimensionInputsProps> = ({
  onChange,
  initialDimensions
}) => {
  const [dimensions, setDimensions] = useState({
    id: initialDimensions?.id || '',
    length: initialDimensions?.length || '',
    height: initialDimensions?.height || '',
    width: initialDimensions?.width || '',
  });

  useEffect(() => {
    if (initialDimensions) {
      setDimensions({
        id: initialDimensions?.id || '',
        length: initialDimensions.length || '',
        height: initialDimensions.height || '',
        width: initialDimensions.width || '',
      });
    }
  }, [initialDimensions]);


  const applyIdentifier = (prefix: string, id: string = '1') => `product-dimensions-${prefix}-${id}`;

  const handleInputChange = (
    field: 'length' | 'height' | 'width',
    value: string
  ) => {
    // Only allow numeric input
    const numericValue = value.replace(/[^0-9]/g, '');

    const newDimensions = {
      ...dimensions,
      [field]: numericValue,
    };

    setDimensions(newDimensions);

    if (onChange) {
      onChange(newDimensions);
    }
  };

  return (
    <div className="grid grid-nogutter flex-wrap gap-3 p-fluid">
      {/* Length Input */}
      <div className="lg:col-4">
        <label
          htmlFor={applyIdentifier('length', dimensions.id)}
          className=" p-text-bold"
        >
          Largo
        </label>
        <div className=" p-bg-white p-border">
          <InputText
            value={dimensions.length}
            onChange={(e) => handleInputChange('length', e.target.value)}
            placeholder="15"
            inputMode="numeric"
            className=""
            maxLength={3}
            name={applyIdentifier('length', dimensions.id)}
            autoComplete="off"
          />
          <span className="p-ml-2 p-text-xs p-text-secondary">cm</span>
        </div>
      </div>

      {/* Height Input */}
      <div className="p-d-flex p-flex-column p-ai-start p-w-8rem">
        <label
          htmlFor={applyIdentifier('height', dimensions.id)}
          className="p-mb-1 p-text-bold"
        >
          Alto
        </label>
        <div className="p-d-flex p-ai-center p-bf-border-color p-p-3 p-bg-white p-border">
          <InputText
            value={dimensions.height}
            onChange={(e) => handleInputChange('height', e.target.value)}
            placeholder="15"
            inputMode="numeric"
            className="p-w-8rem p-h-5 p-border-none p-outline-none p-bg-transparent p-font-medium p-text-center"
            maxLength={3}
            name={applyIdentifier('height', dimensions.id)}
            autoComplete="off"
          />
          <span className="p-ml-2 p-text-xs p-text-secondary">cm</span>
        </div>
      </div>

      {/* Width Input */}
      <div className="p-d-flex p-flex-column p-ai-start p-w-8rem">
        <label
          htmlFor={applyIdentifier('width', dimensions.id)}
          className="p-mb-1 p-text-bold"
        >
          Ancho
        </label>
        <div className="p-d-flex p-ai-center p-bf-border-color p-p-3 p-border-round-right p-bg-white p-border">
          <InputText
            value={dimensions.width}
            onChange={(e) => handleInputChange('width', e.target.value)}
            placeholder="15"
            inputMode="numeric"
            className="p-w-8rem p-h-5 p-border-none p-outline-none p-bg-transparent p-font-medium p-text-center"
            maxLength={3}
            name={applyIdentifier('width', dimensions.id)}
            autoComplete="off"
          />
          <span className="p-ml-2 p-text-xs p-text-secondary">cm</span>
        </div>
      </div>
    </div>
  );
};

export default DimensionInputs;
