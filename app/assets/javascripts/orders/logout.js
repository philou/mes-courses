var mesCourses = mesCourses || {};
mesCourses.orders = mesCourses.orders || {};

mesCourses.orders.logout = {
    startUpdatingTransferRatio: function() {
        return setInterval(function() {
            $('#transfer-ratio').incrementUpTo(100);
        }, 1000);
    },

    onRemoteStoreIFrameLoad: function() {
        mesCourses.refresh.doNow();
    }
};

$(document).ready(mesCourses.orders.logout.startUpdatingTransferRatio);
