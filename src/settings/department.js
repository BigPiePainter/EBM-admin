import http from '@/libs/http'

export const loadDepaetment = data => {
    const args = {
        url: '/department/load',
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

export const editDepaetment = data => {
    const args = {
        url: '/department/edit',
        method: 'POST',
        data
    }
    return http.request(args)
}