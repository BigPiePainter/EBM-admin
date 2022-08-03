import http from '@/libs/http'

export const loadProducts = data => {
    const args = {
        url: '/product/getByPermission',
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

export const getClass = data => {
    const args = {
        url: '/product/getCategory',
        method: 'POST',
        data
    }
    return http.request(args)
}