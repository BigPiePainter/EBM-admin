import http from '@/libs/http'

export const loadProducts = data => {
    const args = {
        url: '/product/product_to_front',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const upLoadProducts = data => {
    const args = {
        url: '/product/product_to_behind',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editProducts = data => {
    const args = {
        url: '/product/product_edit',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteProducts = data => {
    const args = {
        url: '/product/product_delete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const selectProducts = data => {
    const args = {
        url: '/product/product_select',
        method: 'POST',
        data
    }
    return http.request(args)
}