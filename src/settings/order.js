import http from '@/libs/http'

export const getOrder = data => {
    const args = {
        url: '/order/getOrder',
        method: 'POST',
        data,

    }
    return http.request(args)
}

export const addOrder = data => {
    const args = {
        url: '/order/addOrder',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addBrush = data => {
    const args = {
        url: '/order/addBrush',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getBrush = data => {
    const args = {
        url: '/order/getBrush',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getReturn = data => {
    const args = {
        url: '/order/getReturn',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addReturn = data => {
    const args = {
        url: '/order/addReturn',
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

export const getFileProcessStates = data => {
    const args = {
        url: '/order/getFileProcessStates',
        method: 'POST',
        data,
    }
    return http.request(args)
}

export const getMismatchRefundOrders = data => {
    const args = {
        url: '/order/getMismatchRefundOrders',
        method: 'POST',
        data,
    }
    return http.request(args)
}

export const getMismatchFakeOrders = data => {
    const args = {
        url: '/order/getMismatchFakeOrders',
        method: 'POST',
        data,
    }
    return http.request(args)
}



export const deleteFileProcessState = data => {
    const args = {
        url: '/order/deleteFileProcessState',
        method: 'POST',
        data,
    }
    return http.request(args)
}






