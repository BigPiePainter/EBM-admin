import http from '@/libs/http'

export const loadProducts = data => {
    const args = {
        url: '/product/product_to_front',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addProducts = data => {
    const args = {
        url: '/product/product_to_behind',
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