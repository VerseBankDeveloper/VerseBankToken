// SPDX-License-Identifier: MIT
// Sistemas de Pagamentos VerseBank , Versepay é parte integrada a plataforma e sera um dos meios de pagamentos
// ultilizado para o Versegroup e todas as plataformas.
// Versebank.com.br - Verseland.com.br - versepay.com.br - versecard.com.br
// Nossos canais de suportes podem ser listados abaixo
//  hello@versepay.com.br --  help@versepay.com.br --  token@versepay.com.br
//  hello@versebank.com.br -- help@versebank.com.br -- token@versebank.com.br
// whitepaper disponivel em Versetoken.com.br/whitepaper.pdf
// Sistema de responsabilidade VerseGroup,  código publico com todas as atribuições a rede que
// pode ser revogada após a descentralização deste contrato, este contrato se baseia na necessidade
// de pagamentos e recebimentos do VerseGroup sendo estes: VerseBank,   VerseToken,  VerseLand,  VersePay, VerseCard, VerseGlobal.
// Em toda a documentação haverá total transparência do uso deste ecossistema e também poderá ser lido
// em versebank.com.br/pilaresevalores.pdf

pragma solidity ^0.8.2;

contract VerseToken {
    
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    
    string public name = "VersePay";
    string public symbol = "VersePay";
    
    uint public numeroDeMoedas = 21000000000;
    uint public casasDecimais = 8;
    
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
    
    uint public totalSupply = numeroDeMoedas * 10 ** casasDecimais;
    uint public decimals = casasDecimais;
    
    address public contractOwner;
    
    constructor() {
        contractOwner = msg.sender;
        balances[msg.sender] = totalSupply;
    }
    
    function balanceOf(address owner) public view returns(uint) {
        return balances[owner];
    }
    
    function transfer(address to, uint value) public returns(bool) {
        require(balanceOf(msg.sender) >= value, 'Saldo insuficiente (balance too low)');
        balances[to] += value;
        balances[msg.sender] -= value;
        emit Transfer(msg.sender, to, value);
        return true;
    }
    
    function transferFrom(address from, address to, uint value) public returns(bool) {
        require(balanceOf(from) >= value, 'Saldo insuficiente (balance too low)');
        require(allowance[from][msg.sender] >= value, 'Sem permissao (allowance too low)');
        balances[to] += value;
        balances[from] -= value;
        emit Transfer(from, to, value);
        return true;
    }
    
    function approve(address spender, uint value) public returns(bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function createTokens(uint value) public returns(bool) {
        if(msg.sender == contractOwner) {
            totalSupply += value;
    	    balances[msg.sender] += value;
    	    return true;
        }
        return false;
    }

    function destroyTokens(uint value) public returns(bool) {
        if(msg.sender == contractOwner) {
            require(balanceOf(msg.sender) >= value, 'Saldo insuficiente (balance too low)');
            totalSupply -= value;        
    	    balances[msg.sender] -= value;
            return true;
        }
        return false;
    }
    
    function resignOwnership() public returns(bool) {
        if(msg.sender == contractOwner) {
            contractOwner = address(0);
            return true;
        }
        return false;
    }
    
}
