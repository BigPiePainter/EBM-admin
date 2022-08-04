import http from '@/libs/http'

export const getDepartment = data => {
    const args = {
        url: '/department/get',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const deleteDepartment = data => {
    const args = {
        url: '/department/delete',
        method: 'POST',
        data
    }
    return http.request(args)
}

export const addDepartment = data => {
    const args = {
        url: '/department/add',
        method: 'POST',
        data
    }
    return http.request(args)
}


export const modifyDepartment = data => {
    const args = {
        url: '/department/modify',
        method: 'POST',
        data
    }
    return http.request(args)
}

