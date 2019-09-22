__includeOnce('ufs:/ngin/router/controller.js');
__includeOnce('ufs:/bdo/orm/entityset.js');
__includeOnce('ufs:/bdo/orm/entity.js');
__includeOnce('ufs:/goog/array/array.js');
__includeOnce('ufs:/goog/object/object.js');
__includeOnce('ufs:/ngin/router/controller.js');
__includeOnce('ufs:/ngin/keys/classes.js');
__includeOnce('ufs:/ngin/http/error.js');
__includeOnce('ufs:/ngin/http/status.js');

__includeOnce(-1898191188); /* /inteq/library/server/keysUtilities.js */;
__includeOnce(-1898191186); /* /inteq/library/server/queryUtilities.js */;
__includeOnce(-1898147512); /* /inteq/library/server/connection.js */;
__includeOnce(-1898146446); /* /inteq/library/server/session.js */;
__includeOnce(-1898145959); /* /products/INTEQengine/library/QueryAnalyzer.js */;
__includeOnce(-1898145408); /* /products/INTEQengine/library/ClassDefManager.ijs */;
__includeOnce(-1898145684) /* /products/INTEQengine/library/formatters/JSON.js */


__includeOnce(-1895799130) /*/products/Custom/Setores Troller/ExternalViewer/Services/ServiceFEM.ijs*/


var ControllerFEM = function () {
  ngin.router.Controller.call(this);
};

goog.inherits(ControllerFEM, ngin.router.Controller);

ControllerFEM.prototype.getFEM = function (request) {


    if (!!request.params['token'] ){
        var token = request.params['token'];
        try{
            var _service = new ServiceFEM(token)
            
            var lista = _service.getListaDeFEMs(request.getRemoteHost() )

            if ( lista.length>0){
                return this.ok( JSON.stringify(lista) ).as("text/x-json");
            } else {
                result = {}
                result.erro = 'Nenhuma FEM foi localizada'
                return this.notFound( JSON.stringify(result) ).as("text/x-json");
            }
        }catch(e){
            result = {}
            result.erro = 'Token não é válido!'
            return this.badRequest( JSON.stringify(result) ).as("text/x-json");
        }
        
    }else{
        result = {}
        result.erro = 'Não enviado token'
        return this.badRequest( JSON.stringify(result) ).as("text/x-json");
    }

};

ControllerFEM.prototype.getFEMsLMPintura = function (request) {


    if (!!request.params['token'] ){
        var token = request.params['token'];
        try{
            var _service = new ServiceFEM(token)

            var lista = _service.getListaDeFEMsNaPintura(request.getRemoteHost() )

            if ( lista.length>0){
                return this.ok( JSON.stringify(lista) ).as("text/x-json");
            } else {
                result = {}
                result.erro = 'Nenhuma FEM foi localizada'
                return this.notFound( JSON.stringify(result) ).as("text/x-json");
            }
        }catch(e){
            result = {}
            result.erro = 'Token não é válido!'
            return this.badRequest( JSON.stringify(result) ).as("text/x-json");
        }

    }else{
        result = {}
        result.erro = 'Não enviado token'
        return this.badRequest( JSON.stringify(result) ).as("text/x-json");
    }

};

module.exports = ControllerFEM;