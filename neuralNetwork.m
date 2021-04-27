classdef neuralNetwork < handle
    properties
        input_size;
        hidden_units;
        output_size;
        eyeoutput;
        eyehidden;
        V;
        W;
        input_activation;
        hidden_activation;
        output_activation;
        loss = [];
        grouping_factor = [];
    end
    methods (Static)
        function self = neuralNetwork(input_size, hidden_units, output_size)
            self.input_size = input_size;
            self.hidden_units = hidden_units;
            self.output_size = output_size;
            self.V = rand(hidden_units, input_size);
            self.W = rand(output_size, hidden_units);
        end
        function[test] = test()
            test = 1;
        end
    end
    methods
        function s = sigmoid(self, x)
            s = (1./(1+exp(-x)))';
        end
        function ds = d_sigmoid(self, x)
            ds = (x.*(1-x));
        end
        function r = relu(self, x)
            r = ((x > 0) .* x)';
        end
        function dr = d_relu(self, x)
            dr = x > 0;
        end
        function output = feedForward(self, input)
            self.input_activation = input;
            vs = self.V * input;
            self.hidden_activation = self.sigmoid(vs);
            self.output_activation = self.W * self.hidden_activation';
            output = self.output_activation;
        end
        function reduced = reduce(self, input)
            vs = self.V * input';
            reduced = self.sigmoid(vs);
        end
		function dcdy = dc_dy(self, label, output)
			dcdy = -2*(label'-output');
		end
		function dydw = dy_dw(self)
			for k = 1:self.output_size
				uk = zeros(self.output_size, 1);
				uk(k) = 1;
				dydw{k} = uk*self.hidden_activation;
			end
		end
		function grad_w = grad_W(self, label, output)
			grad_w = zeros(self.output_size, self.hidden_units);
			dcdy = self.dc_dy(label, output);
			dydw = self.dy_dw();
			for k = 1:self.output_size
				grad_w(k,:) = grad_w(k,:) + dcdy * dydw{k};
			end
		end
		function dydh = dy_dh(self)
			dydh = self.W;
		end
		function dhdv = dh_dv(self, input)
			for j = 1:self.hidden_units
				uj = zeros(self.hidden_units, 1);
				uj(j) = 1;
				hj = self.hidden_activation(j);
                dhdv{j} = uj*self.d_sigmoid(hj)*input';
			end
		end
		function grad_v = grad_V(self, input, label, output)
			grad_v = zeros(self.hidden_units, self.input_size);
			dcdy = self.dc_dy(label, output);
			dydh = self.dy_dh();
			dhdv = self.dh_dv(input);
			
			for j = 1:self.hidden_units
				grad_v(j,:) = grad_v(j,:) + dcdy*dydh*dhdv{j};
			end
		end
        function loss = train(self, inputs, labels, gamma, batch_size)
            loss = 0;
			grad_w = zeros(self.output_size, self.hidden_units);
			grad_v = zeros(self.hidden_units, self.input_size);
			
            for i = 1:batch_size
                input = inputs(i,:)';
                label = labels(i,:)';
                output = self.feedForward(input);
                loss = loss + (label-output)'*(label-output);
				
				grad_w = grad_w + self.grad_W(label, output);
				
				grad_v = grad_v + self.grad_V(input, label, output);
            end
            
            self.loss(end+1) = loss / batch_size;
            self.W = self.W - gamma * grad_w / batch_size;
            self.V = self.V - gamma * grad_v / batch_size;
        end
        function add_grouping_factor(self, gf)
           self.grouping_factor = [self.grouping_factor; gf];
        end
    end
end