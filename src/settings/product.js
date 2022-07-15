import http from '@/libs/http'

export const loadProducts = data => {
    const args = {
        url: '/product/product_to_front',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addProduct = data => {
    const args = {
        url: '/product/add',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editProduct = data => {
    const args = {
        url: '/product/product_edit',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteProduct = data => {
    const args = {
        url: '/product/product_delete',
        method: 'POST',
        data
    }
    return http.request(args)
}