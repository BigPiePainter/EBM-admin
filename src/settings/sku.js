import http from '@/libs/http'

export const loadSkus = data => {
    const args = {
        url: '/sku/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addSkus = data => {
    const args = {
        url: '/sku/add',
        method: 'POST',
        data,
        json: true,
    }
    return http.request(args)
}

// export const editSku = data => {
//     const args = {
//         url: '/sku/edit',
//         method: 'POST',
//         data
//     }
//     return http.request(args)
// }

export const deleteSku = data => {
    const args = {
        url: '/sku/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}
