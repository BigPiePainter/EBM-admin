import http from '@/libs/http'

export const loadManufacturers = data => {
    const args = {
        url: '/manufacturer/get',
        method: 'POST',
        data
    }
    return http.request(args)
}


export const addManufacturer = data => {
    const args = {
        url: '/manufacturer/add',
        method: 'POST',
        data
    }
    return http.request(args)
}


export const deleteManufacturer = data => {
    const args = {
        url: '/manufacturer/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}


export const editManufacturer = data => {
    const args = {
        url: '/manufacturer/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}