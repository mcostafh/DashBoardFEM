

var ServiceFEM = function (token) {
    this._session = session.loginByAuthToken( token )

};


ServiceFEM.prototype.getListaDeFEMs = function ( host) {

    var result = []
    try{
        var dsFEM = connection.getDataSet("
        select d.atni_021Numero_FEM_V, d.ATSV_021CX_Transferencia_v, d.atsv_021Chassi_v, d.pkni_021cod_pedido,
            d.fkni_021cod_modelo,
            d.atdt_021Data_v, d.atdt_021data_alteracao, d.atsv_021cod_ano_fabr_v, d.atsv_021cod_ano_mod_v,
            d.atni_021cod_carroceria_v , d.atni_021cod_cor_carr_v, d.atni_021cod_cor_capo_v

        from DOP021TB_PEDIDO d
        inner join recurso v on ( v.chave=d.fkni_021cod_modelo)

        where d.atni_021posicao_v>=36 and d.atni_021posicao_v<=38
        order by atdt_021data_alteracao")

        if ( dsFEM.recordCount>0){

            for (dsFEM.first(); !dsFEM.eof; dsFEM.next()) {
                 var _res={}

                _res.fem  = dsFEM.atni_021Numero_FEM_V
                _res.pedido = dsFEM.pkni_021cod_pedido
                
                _res.catalogo = dsFEM.fkni_021cod_modelo.tipoveiculo.codigo
                _res.modelo = dsFEM.fkni_021cod_modelo.codigo
                _res.nomeModelo = dsFEM.fkni_021cod_modelo.nome
                _res.tipoTransmissao = (dsFEM.fkni_021cod_modelo.ztipotransmissao == 'M' ? 'Manual' : 'Automático')

                _res.chassi = dsFEM.atsv_021Chassi_v

                _res.carroceria = dsFEM.atni_021cod_carroceria_v.codigo
                _res.corCarroceria = dsFEM.atni_021cod_cor_carr_v.codigo
                _res.corCapo = dsFEM.atni_021cod_cor_capo_v.codigo
                
                _res.anoFab = dsFEM.atsv_021cod_ano_fabr_v ? dsFEM.atsv_021cod_ano_fabr_v : ''
                _res.anoMod = dsFEM.atsv_021cod_ano_mod_v ? dsFEM.atsv_021cod_ano_mod_v : ''

                _res.cxTransf = dsFEM.ATSV_021CX_Transferencia_v
                _res.dataAlteracao = dsFEM.atdt_021data_alteracao.toString('dd/mm/yyyy hh:mm:ss')


                _res.host = host
                result.push(_res)
            }
        }


    } catch(e){
        var _res = {};
        _res.erro = e.message;
        result.push(_res);
    }
    
    
   return result
}

ServiceFEM.prototype.getListaDeFEMsNaPintura = function ( host) {

    var result = []
    try{
        var dsFEM = connection.getDataSet("
        select d.atni_021Numero_FEM_V, d.ATSV_021CX_Transferencia_v, d.atsv_021Chassi_v, d.pkni_021cod_pedido,
            d.fkni_021cod_modelo,
            d.atdt_021Data_v, d.atdt_021data_alteracao, d.atsv_021cod_ano_fabr_v, d.atsv_021cod_ano_mod_v,
            d.atni_021cod_carroceria_v , d.atni_021cod_cor_carr_v, d.atni_021cod_cor_capo_v

        from DOP021TB_PEDIDO d
        inner join recurso v on ( v.chave=d.fkni_021cod_modelo)

        where d.atni_021posicao_v>=32 and d.atni_021posicao_v<=36
        order by atdt_021data_alteracao")

        if ( dsFEM.recordCount>0){
            var _dsAgrupa = new DataSet();
            _dsAgrupa.createField("catalogo", "string", 20);
            _dsAgrupa.createField("tracao", "string", 20);
            _dsAgrupa.createField("data", "date");
            _dsAgrupa.create();
            _dsAgrupa.indexFieldNames = 'catalogo;tracao;data'

            dsFEM.indexFieldNames = 'atdt_021data_alteracao;fkni_021cod_modelo.tipoveiculo;fkni_021cod_modelo.ztipotransmissao'

            dsFEM.first()
            while(!dsFEM.eof){

                var tipo = (dsFEM.fkni_021cod_modelo.ztipotransmissao == 'M' ? 'Manual' : 'Automático')

                var _res={}
                _res.catalogo = dsFEM.fkni_021cod_modelo.tipoveiculo.codigo
                _res.tracao =tipo
                _res.dataAlteracao = dsFEM.atdt_021data_alteracao //.toString('dd/mm/yyyy hh:mm:ss')
                
                var modelo= dsFEM.fkni_021cod_modelo.tipoveiculo
                var tracao = dsFEM.fkni_021cod_modelo.ztipotransmissao
                
                var _detalhe = []
                while(!dsFEM.eof && modelo == dsFEM.fkni_021cod_modelo.tipoveiculo &&
                    tracao == dsFEM.fkni_021cod_modelo.ztipotransmissao && _res.dataAlteracao == dsFEM.atdt_021data_alteracao
                 ){
                    try{
                        _detalhe.push( {fem : dsFEM.atni_021Numero_FEM_V,
                                        pedido:dsFEM.pkni_021cod_pedido,
                                        tracao: tipo,
                                        catalogo: dsFEM.fkni_021cod_modelo.tipoveiculo.codigo,
                                        modelo: dsFEM.fkni_021cod_modelo.codigo,
                                        nomeModelo :   dsFEM.fkni_021cod_modelo.nome,
                                        carroceria: dsFEM.atni_021cod_carroceria_v.codigo,
                                        corCarroceria:  dsFEM.atni_021cod_cor_carr_v.codigo,
                                        corCapo:dsFEM.atni_021cod_cor_capo_v.codigo

                                        } )

                        var tipo = (dsFEM.fkni_021cod_modelo.ztipotransmissao == 'M' ? 'Manual' : 'Automático')
                    }catch(e){
                    }
                    dsFEM.next()
                }
                _res.detalhe = _detalhe
                _res.host = host
                result.push(_res)
            }
        }


    } catch(e){
        var _res = {};
        _res.erro = e.message;
        result.push(_res);
    }


   return result
}

