%% 输入及校验位生成
n = 8;
data = randi([0 1], n, 1); %发送数据
ver = [1,0,0,0,0,0,1,1,1]'; %校验数
m = [data; zeros(8,1)]; %在发送数据矩阵下添加八行一列的零矩阵
[~, rema_1] = Mod_2(m, ver); %模2除余数保存在rema_1里
data_r = [data; rema_1]; %把模2除后的余数加到要发送数据下边作为校验位，把生成的新CRC矩阵作为发送数据送入信道
data_input=data';
flag = 1; 
%% 输入信道传输并校验
while 1   
    %二进制信道
    p0_0 = 0.2; 
    p1_0 = 0.1;
    %校验
    for i = 1: length(data_r)/2
        if data_r(i) == 0 %检验0位是否正确，正确遍历下一位，不正确赋1
            if randsrc(1,1,[0 1;1-p0_0, p0_0]) == 1 %生成随机矩阵，实现信道的随机传输
                data_r(i) = 1;
            end
        else
            if randsrc(1,1,[0 1;1-p1_0, p1_0]) == 1 %检验1位是否正确，正确遍历下一位，不正确赋0
                data_r(i) = 0;
            end
            
        end
        
    end
    [~, rema_crc] = Mod_2(data_r, ver); %标志位赋值
    flag = sum(rema_crc);
   
 %% 判定传输是否有错
    if flag ~= 0
        disp('本次传输有错，要求重传');
    else
        disp('本次传输正确')
        break;
    end
end
a_num=(data_r(1:n))';
msgbox({ '输入：',num2str(data_input),'输出：',num2str(a_num)},'传输结果','help')

%%  模2除函数
function [quo, rema] = Mod_2(b, a)
quo = []; %商矩阵
rema = []; %余数矩阵
leng1 = length(b);
leng2 = length(a);
for i = 1: leng1-leng2+1
    if b(i) == 0
        quo = [quo, 0];
    else
        quo = [quo, 1];
        b(i:i+leng2-1) = xor(b(i:i+leng2-1), a);
    end
end
rema = b(end-leng2+2: end);
end

