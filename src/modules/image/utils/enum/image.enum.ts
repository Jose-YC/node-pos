export enum modules {
    PROFILE='profile',
    PRODUCT='product',
    // otros modulos que necesiten una imagen
}

export const police = {
    [modules.PROFILE]: { 
        publicid: (userid:number) => `${userid}/avatar`
    },

    [modules.PRODUCT]: { 
        publicid: (userid:number, name:string) => `${userid}/product/${name}-${Date.now()}`
    }
}