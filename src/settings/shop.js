import http from '@/libs/http'

export const getShop = data => {
    const args = {
        url: '/shop/get',
        method: 'POST',
        data,
    }
    return http.request(args)
}

export const deleteShop = data => {
    const args = {
        url: '/shop/delete',
        method: 'POST',
        data,
    }
    return http.request(args)
}

export const addShop = data => {
    const args = {
        url: '/shop/add',
        method: 'POST',
        data,
    }
    return http.request(args)
}