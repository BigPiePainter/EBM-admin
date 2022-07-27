import http from '@/libs/http'

export const getDepaetment = data => {
    const args = {
        url: '/department/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteDepaetment = data => {
    const args = {
        url: '/department/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addDepaetment = data => {
    const args = {
        url: '/department/add',
        method: 'POST',
        data
    }
    return http.request(args)
}