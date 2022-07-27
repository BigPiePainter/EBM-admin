import http from '@/libs/http'

export const loadOrder = data => {
    const args = {
        url: '/Order/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addOrder = data => {
    const args = {
        url: '/Order/add',
        method: 'POST',
        data
    }
    return http.request(args)
}