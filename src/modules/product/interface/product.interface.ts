
export interface RawProduct {
    id:              number,
    sku:             string,
	name:            string,
    description:     string,
    image:           string,
    category_name:   string,
    min_order_qty:   number,
    min_stock:       number,
    status:          boolean
}

export interface RawCatalogProduct {
    id:              number,
	name:            string,
    image:           string,
    category_name:   string,
    stock:           number,
    price_selling:   number    
}

export interface RawProductById {
    id:              number,
    sku:             string,
    name:            string,
    description:     string,
    image:           string,
    category_id:     number,
    category_name:   string,
    min_order_qty:   number,
    min_stock:       number,
    status:          boolean,
    stock:           number,
    price_buying:    number,
    price_selling:   number
}