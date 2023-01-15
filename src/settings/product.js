import http from '@/libs/http'

export const loadProducts = data => {
    const args = {
        url: '/product/getByPermission',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const loadDeletedProducts = data => {
    const args = {
        url: '/product/getDeprecatedByPermission',
        method: 'POST',
        data
    }
    return http.request(args)
}




export const addProducts = data => {
    const args = {
        url: '/product/add',
        method: 'POST',
        data
    }
    console.log(args)
    return http.request(args)
}

export const editProduct = data => {
    const args = {
        url: '/product/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteProduct = data => {
    const args = {
        url: '/product/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const absoluteDeleteProduct = data => {
    const args = {
        url: '/product/absoluteDelete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const restoreProduct = data => {
    const args = {
        url: '/product/restore',
        method: 'POST',
        data
    }
    return http.request(args)
}



export const getClass = data => {
    const args = {
        url: '/product/getCategory',
        method: 'POST',
        data
    }
    return http.request(args)
}


export const getMismatchProducts = data => {
    const args = {
        url: '/product/getMismatchProducts',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const productSynchronization = data => {
    const args = {
        url: '/product/productSynchronization',
        method: 'POST',
        data
    }
    return http.request(args)
}

//用于财务获取商品清单
export const economyGetAllProducts = data => {
    const args = {
        url: '/product/getAll',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const economyGetAllProductsDetails = data => {
    const args = {
        url: '/product/getAllDetails',
        method: 'POST',
        data
    }
    return http.request(args)
}