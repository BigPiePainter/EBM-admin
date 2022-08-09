import http from '@/libs/http'

export const getCategory = data => {
    const args = {
        url: '/category/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addCategory = data => {
    const args = {
        url: '/category/add',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editCategory = data => {
    const args = {
        url: '/category/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addHistoryCategory = data => {
    const args = {
        url: '/category/addHistory',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const getHistoryCategory = data => {
    const args = {
        url: '/category/getHistorys',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editHistoryCategory = data => {
    const args = {
        url: '/category/modifyHistory',
        method: 'POST',
        data
    }
    return http.request(args)
}