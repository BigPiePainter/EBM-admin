import http from '@/libs/http'

export const loadProducts = data => {
    const args = {
        url: '/product/load/product_to_front',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const upLoadProducts = data => {
    const args = {
        url: '/product/load/product_to_behind',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editProducts = data => {
    const args = {
        url: '/product/load/product_edit',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteProducts = data => {
    const args = {
        url: '/product/load/product_delete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const selectProducts = data => {
    const args = {
        url: '/product/load/product_select',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const loadSku = data => {
    const args = {
        url: '/product/load/sku_to_front',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const upLoadSku = data => {
    const args = {
        url: '/product/load/sku_to_behind',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editSku = data => {
    const args = {
        url: '/product/load/sku_edit',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteSku = data => {
    const args = {
        url: '/product/load/sku_delete',
        method: 'POST',
        data
    }
    return http.request(args)
}