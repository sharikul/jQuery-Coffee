# intro.js is too confusing to even translate. 

`(function( global, factory ) {

    if ( typeof module === "object" && typeof module.exports === "object" ) {
            module.exports = global.document ?
                    factory( global, true ) :
                    function( w ) {
                            if ( !w.document ) {
                                    throw new Error( "jQuery requires a window with a document" );
                            }
                            return factory( w );
                    };
    } else {
            factory( global );
    }

// Pass this if window is not defined yet
}(typeof window !== "undefined" ? window : this, function( window, noGlobal ) {`