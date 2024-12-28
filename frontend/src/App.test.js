import React from 'react';
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders 3-Tier Application heading', () => {
    render(<App />);
    const headingElement = screen.getByText(/3-Tier Application/i);
    expect(headingElement).toBeInTheDocument();
});

test('renders Data from Backend heading', () => {
    render(<App />);
    const subHeadingElement = screen.getByText(/Data from Backend/i);
    expect(subHeadingElement).toBeInTheDocument();
});
