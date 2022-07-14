import http from '@/libs/http'

export const loadSkus = data => {
    const args = {
        url: '/sku/sku_to_front',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addSkus = data => {
    const args = {
        url: '/sku/sku_to_behind',
        method: 'POST',
        data   
    }
    return http.request(args)
}

export const editSku = data => {
    const args = {
        url: '/sku/sku_edit',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteSku = data => {
    const args = {
        url: '/sku/sku_delete',
        method: 'POST',
        data
    }
    return http.request(args)
}