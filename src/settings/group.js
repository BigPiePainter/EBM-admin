import http from '@/libs/http'

export const loadGroup = data => {
    const args = {
        url: '/group/load',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteGroup = data => {
    const args = {
        url: '/group/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const editGroup = data => {
    const args = {
        url: '/group/edit',
        method: 'POST',
        data
    }
    return http.request(args)
}