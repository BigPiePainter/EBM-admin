import http from '@/libs/http'

export const getOrder = data => {
    const args = {
        url: '/Order/getOrder',
        method: 'POST',
        data,

    }
    return http.request(args)
}

export const addOrder = data => {
    const args = {
        url: '/Order/addOrder',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addBrush = data => {
    const args = {
        url: '/Order/addBrush',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getBrush = data => {
    const args = {
        url: '/Order/getBrush',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getReturn = data => {
    const args = {
        url: '/Order/getReturn',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addReturn = data => {
    const args = {
        url: '/Order/addReturn',
        method: 'POST',
        data
    }
    return http.request(args)
}


export const fileUpload = (data, event) => {
    const args = {
        url: '/order/fileUpload',
        method: 'POST',
        data,
        file: true,
        onUploadProgress: event
    }
    return http.request(args)
}


