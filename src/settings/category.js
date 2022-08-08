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
        url: '/category/edit',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteCategory = data => {
    const args = {
        url: '/category/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}